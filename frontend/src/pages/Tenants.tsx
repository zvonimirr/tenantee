import { Box, Button, Center, Grid, GridItem, Spinner, Stack, Text, useDisclosure } from '@chakra-ui/react';
import { useCallback, useMemo, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import ConfirmModal from '../components/Modals/ConfirmModal';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import AddTenantModal from '../components/Tenant/Modals/AddTenantModal';
import EditTenantModal from '../components/Tenant/Modals/EditTenantModal';
import TenantCard from '../components/Tenant/TenantCard';
import { useFetch } from '../hooks/useFetch';
import { useNotification } from '../hooks/useNotification';
import { tenantApiService } from '../services/api/TenantApiService';
import { Tenant, TenantDto, TenantUpdateDto } from '../types/tenant';

function Tenants() {
    const { showError, showSuccess } = useNotification();

    const {
        data: { tenants } = { tenants: [] },
        isLoading,
        mutate,
    } = useFetch(
        tenantApiService.apiRoute,
        tenantApiService.list,
        useMemo(() => ({
            onError: () => {
                showError(
                    'Error',
                    'An error occurred while trying to fetch tenants',
                );
            }
        }), [showError])
    );

    const navigate = useNavigate();
    const [selectedTenant, setSelectedTenant] = useState<Nullable<Tenant>>(null);
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

    const onTenantCardClick = useCallback(
        (tenant: Tenant) => navigate(`/tenants/${tenant.id}`),
        [navigate],
    );

    const onAddTenantSubmit = useCallback(
        async (tenant: TenantDto) => {
            try {
                await tenantApiService.add(tenantApiService.apiRoute, tenant);

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
                await tenantApiService.update(
                    tenantApiService.apiRoute,
                    tenant
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
                await tenantApiService.delete(tenantApiService.apiRoute, selectedTenant.id);

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
                        {tenants.map((tenant) => (
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
                        {!tenants.length && (
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
