import {
    Box,
    Button,
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
import {
    Tenant,
    TenantDto,
    TenantList,
    TenantUpdateDto,
} from '../types/tenant';
import {
    tenantApiService,
    TenantApiService,
} from '../services/api/TenantApiService';
import TenantCard from '../components/Tenant/TenantCard';
import ConfirmModal from '../components/Modals/ConfirmModal';
import { isEmpty } from 'ramda';
import AddTenantModal from '../components/Tenant/Modals/AddTenantModal';
import EditTenantModal from '../components/Tenant/Modals/EditTenantModal';
import { useNavigate } from 'react-router-dom';

function Tenants() {
    const { data, error, isValidating, mutate } = useSWR<TenantList>(
        TenantApiService.listTenantsPath,
        tenantApiService.getTenants,
    );
    const navigate = useNavigate();
    const [selectedTenant, setSelectedTenant] = useState<Tenant | null>(null);
    const {
        isOpen: isAddNewTenantModalOpen,
        onOpen: openAddNewTenantModal,
        onClose: closeAddNewTenantModal,
    } = useDisclosure();
    const {
        isOpen: isEditTenantModalOpen,
        onOpen: openEditTenantModal,
        onClose: closeEditTenantModal,
    } = useDisclosure();
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

    const onTenantCardClick = useCallback(
        (tenant: Tenant) => navigate(`/tenants/${tenant.id}`),
        [navigate],
    );

    const onAddTenantSubmit = useCallback(
        async (tenant: TenantDto) => {
            try {
                await tenantApiService.addTenant(
                    TenantApiService.addTenantPath(),
                    tenant,
                );

                showSuccess(
                    'Tenant added',
                    'New tenant has been added successfully',
                );
            } catch (e) {
                showError(
                    'Error',
                    'An error occurred while trying to add a new tenant',
                );
            } finally {
                mutate();
                closeAddNewTenantModal();
            }
        },
        [mutate],
    );

    const onEditTenantSubmit = useCallback(
        async (tenant: TenantUpdateDto) => {
            try {
                await tenantApiService.updateTenant(
                    TenantApiService.updateTenantPath(tenant.id),
                    tenant,
                );

                showSuccess(
                    'Tenant update',
                    `Tenant ${tenant.first_name} ${tenant.last_name} has been updated successfully`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to update ${selectedTenant?.name} property`,
                );
            } finally {
                setSelectedTenant(null);
                closeEditTenantModal();
                mutate();
            }
        },
        [mutate, selectedTenant],
    );

    const onTenantDeleteClick = useCallback(async () => {
        if (selectedTenant) {
            try {
                await tenantApiService.deleteTenant(
                    TenantApiService.deleteTenantPath(selectedTenant.id),
                );

                showSuccess(
                    'Tenant deleted',
                    `${selectedTenant.name} was deleted successfully`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to delete ${selectedTenant.name}`,
                );
            } finally {
                setSelectedTenant(null);
                mutate();
                closeConfirmModal();
            }
        }
    }, [selectedTenant, showError, mutate, closeConfirmModal]);

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
                message={`Are you sure you want to delete ${selectedTenant?.name}?`}
                onConfirm={onTenantDeleteClick}
                onCancel={closeConfirmModal}
            />
            <AddTenantModal
                isOpen={isAddNewTenantModalOpen}
                onClose={closeAddNewTenantModal}
                onSubmit={onAddTenantSubmit}
            />
            <EditTenantModal
                isOpen={isEditTenantModalOpen}
                onClose={closeEditTenantModal}
                onSubmit={onEditTenantSubmit}
                tenant={selectedTenant}
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
                                        onClick={onTenantCardClick}
                                        onDeleteClick={(tenant) => {
                                            setSelectedTenant(tenant);
                                            openConfirmModal();
                                        }}
                                        onEditClick={(tenant) => {
                                            setSelectedTenant(tenant);
                                            openEditTenantModal();
                                        }}
                                    />
                                </GridItem>
                            ))}
                        {!isError &&
                            !isLoading &&
                            data &&
                            isEmpty(data.tenants) && (
                            <GridItem colSpan={3}>
                                <Text fontSize="lg" textAlign="center">
                                    {
                                        'You don\'t have any tenants yet. Click the button below to add one.'
                                    }
                                </Text>
                            </GridItem>
                        )}
                    </Grid>
                    <Center>
                        <Button
                            colorScheme="teal"
                            width="sm"
                            onClick={openAddNewTenantModal}
                            disabled={isLoading}>
                            Add New Tenant
                        </Button>
                    </Center>
                </Stack>
            </PageContainer>
        </Box>
    );
}

export default Tenants;
