import {
    Box,
    Center,
    Grid,
    GridItem,
    Spinner,
    Stack,
    Text,
    useDisclosure,
} from '@chakra-ui/react';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import useSWR from 'swr';
import { useCallback, useEffect, useMemo, useState } from 'react';
import { useNotification } from '../hooks/useNotification';
import { Tenant, TenantList } from '../types/tenant';
import {
    tenantApiService,
    TenantApiService,
} from '../services/api/TenantApiService';
import TenantCard from '../components/Tenant/TenantCard';
import ConfirmModal from '../components/Modals/ConfirmModal';

function Tenants() {
    const { data, error, isValidating, mutate } = useSWR<TenantList>(
        TenantApiService.listTenantsPath,
        tenantApiService.getTenants,
    );
    const [tenantToDelete, setTenantToDelete] = useState<Tenant | null>(null);
    const {
        isOpen: isConfirmModalOpen,
        onOpen: openConfirmModal,
        onClose: closeConfirmModal,
    } = useDisclosure();
    const { showError, showSuccess } = useNotification();

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, isValidating, error],
    );

    const isError = useMemo(() => error !== undefined, [error]);

    const onTenantDeleteClick = useCallback(async () => {
        if (tenantToDelete) {
            try {
                await tenantApiService.deleteTenant(
                    TenantApiService.deleteTenantPath(tenantToDelete.id),
                );

                showSuccess(
                    'Tenant deleted',
                    `${tenantToDelete.name} was deleted successfully`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to delete ${tenantToDelete.name}`,
                );
            } finally {
                setTenantToDelete(null);
                mutate();
                closeConfirmModal();
            }
        }
    }, [tenantToDelete, showError, mutate, closeConfirmModal]);

    useEffect(() => {
        if (isError) {
            showError(
                'Error',
                'An error occurred while trying to load your tenants',
            );
        }
    }, [isError]);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmModalOpen}
                title="Delete Tenant"
                message={`Are you sure you want to delete ${tenantToDelete?.name}?`}
                onConfirm={onTenantDeleteClick}
                onCancel={closeConfirmModal}
            />

            <Breadcrumbs items={[{ href: '/tenants', label: 'Tenants' }]} />
            <PageContainer>
                <Text fontSize="2xl">Your Tenants</Text>
                <Stack spacing={4}>
                    <Grid templateColumns="repeat(3, 1fr)" gap={6}>
                        {isLoading && (
                            <GridItem colSpan={3}>
                                <Center>
                                    <Spinner size="lg" />
                                </Center>
                            </GridItem>
                        )}
                        {!isError &&
                            !isLoading &&
                            data &&
                            data.tenants.map((tenant) => (
                                <GridItem key={tenant.id}>
                                    <TenantCard
                                        tenant={tenant}
                                        onDeleteClick={(tenant) => {
                                            setTenantToDelete(tenant);
                                            openConfirmModal();
                                        }}
                                    />
                                </GridItem>
                            ))}
                    </Grid>
                </Stack>
            </PageContainer>
        </Box>
    );
}

export default Tenants;
