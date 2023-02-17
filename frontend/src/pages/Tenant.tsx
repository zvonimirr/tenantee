import {
    Box,
    Center,
    Checkbox,
    Flex,
    Grid,
    GridItem,
    Select,
    Spinner,
    Stack,
    Text,
    useDisclosure,
} from '@chakra-ui/react';
import { IconArrowBack } from '@tabler/icons-react';
import { isEmpty } from 'ramda';
import { useCallback, useMemo, useRef, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import ConfirmModal from '../components/Modals/ConfirmModal';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import PropertyCard from '../components/Property/PropertyCard';
import TenantCommunicationList from '../components/Tenant/TenantCommunicationList';
import { useFetch } from '../hooks/useFetch';
import { useNotification } from '../hooks/useNotification';
import { propertyApiService } from '../services/api/PropertyApiService';
import { rentApiService } from '../services/api/RentApiService';
import { tenantApiService } from '../services/api/TenantApiService';
import { Property } from '../types/property';
import { Rent } from '../types/rent';
import { Communication } from '../types/tenant';

function TenantPage() {
    const { id } = useParams();
    const navigate = useNavigate();
    const { showError, showSuccess } = useNotification();

    const {
        data: tenant,
        isError: isTenantError,
        isLoading: isTenantLoading,
        mutate: mutateTenant,
    } = useFetch([tenantApiService.apiRoute, id], tenantApiService.get);

    const {
        data: { rents } = { rents: [] },
        isError: isRentsError,
        isLoading: isRentsLoading,
        mutate: mutateRents,
    } = useFetch(
        [tenant?.id ? tenantApiService.apiRoute : null, tenant?.id],
        tenantApiService.rents,
    );

    const { data: { properties: allProperties } = { properties: [] } } =
        useFetch(propertyApiService.apiRoute, propertyApiService.list);

    const {
        isOpen: isConfirmAddModalOpen,
        onOpen: openConfirmAddModal,
        onClose: closeConfirmAddModal,
    } = useDisclosure();
    const {
        isOpen: isConfirmRemoveModalOpen,
        onOpen: openConfirmRemoveModal,
        onClose: closeConfirmRemoveModal,
    } = useDisclosure();

    const {
        isOpen: isConfirmRemoveCommunicationModalOpen,
        onOpen: openConfirmRemoveCommunicationModal,
        onClose: closeConfirmRemoveCommunicationModal,
    } = useDisclosure();

    const [selectedCommunication, setSelectedCommunication] =
        useState<Communication | null>(null);

    const properties = useMemo(() => tenant?.properties, [tenant]);

    const [selectedProperty, setSelectedProperty] = useState<Property | null>(
        null,
    );

    const selectRef = useRef<HTMLSelectElement>(null);

    const breadcrumbs = useMemo(
        () => [
            {
                label: 'Tenants',
                href: '/tenants',
            },
            {
                label: tenant?.name,
                href: `/tenants/${tenant?.id}`,
            },
        ],
        [tenant],
    );

    const onRentStatusUpdate = useCallback(
        async (rent: Rent) => {
            console.log(rent);
            try {
                await rentApiService.mark(rent.id, !rent.paid);
                showSuccess(
                    'Rent status updated',
                    'Successfully updated the status of the rent',
                );
            } catch {
                showError(
                    'Error',
                    'An error occured while trying to update the rent status.',
                );
            } finally {
                mutateRents();
            }
        },
        [mutateRents, showError, showSuccess],
    );

    const onTenantAddSubmit = useCallback(async () => {
        if (tenant && selectedProperty && selectRef.current) {
            try {
                await propertyApiService.addTenant(
                    selectedProperty.id,
                    tenant.id,
                );

                showSuccess(
                    'Tenant added',
                    `${tenant.name} was added to ${selectedProperty.name}.`,
                );
            } catch (e) {
                showError(
                    'Error',
                    'An error occured while trying to add the tenant to the property.',
                );
            } finally {
                setSelectedProperty(null);
                mutateTenant();
                selectRef.current.value = '';
                closeConfirmAddModal();
            }
        }
    }, [
        tenant,
        selectedProperty,
        showSuccess,
        showError,
        mutateTenant,
        closeConfirmAddModal,
    ]);

    const onTenantRemoveSubmit = useCallback(async () => {
        if (selectedProperty && tenant) {
            try {
                await propertyApiService.removeTenant(
                    selectedProperty.id,
                    tenant.id,
                );

                showSuccess(
                    'Tenant removed',
                    `${tenant.name} was removed from ${selectedProperty.name}`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to remove ${tenant.name} from ${selectedProperty.name}`,
                );
            } finally {
                setSelectedProperty(null);
                closeConfirmRemoveModal();
                mutateTenant();
            }
        }
    }, [
        selectedProperty,
        tenant,
        showSuccess,
        showError,
        closeConfirmRemoveModal,
        mutateTenant,
    ]);

    const onTenantAddCancel = useCallback(() => {
        setSelectedProperty(null);
        closeConfirmAddModal();
    }, [closeConfirmAddModal]);

    const onCommunicationAdd = useCallback(
        async (communication: Omit<Communication, 'id'>) => {
            if (tenant) {
                try {
                    await tenantApiService.addCommunication(
                        tenant.id,
                        communication,
                    );

                    showSuccess(
                        'Communication added',
                        `${communication.type} was added to ${tenant.name}.`,
                    );

                    mutateTenant();
                } catch (e) {
                    showError(
                        'Error',
                        'An error occured while trying to add the communication to the tenant.',
                    );
                }
            }
        },
        [tenant, showSuccess, showError, mutateTenant],
    );

    const onCommunicationDelete = useCallback(
        (communicationId: string) => {
            const communication = tenant?.communications.find(
                (c) => c.id === communicationId,
            );

            if (communication) {
                setSelectedCommunication(communication);
                openConfirmRemoveCommunicationModal();
            }
        },
        [tenant, openConfirmRemoveCommunicationModal],
    );

    const onCommunicationRemoveSubmit = useCallback(async () => {
        if (selectedCommunication && tenant) {
            try {
                await tenantApiService.removeCommunication(
                    tenant.id,
                    selectedCommunication.id,
                );

                showSuccess(
                    'Communication removed',
                    `${selectedCommunication.type} was removed from ${tenant.name}`,
                );
            } catch (e) {
                showError(
                    'Error',
                    `An error occurred while trying to remove ${selectedCommunication.type} from ${tenant.name}`,
                );
            } finally {
                setSelectedCommunication(null);
                closeConfirmRemoveCommunicationModal();
                mutateTenant();
            }
        }
    }, [
        selectedCommunication,
        tenant,
        showSuccess,
        showError,
        closeConfirmRemoveCommunicationModal,
        mutateTenant,
    ]);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmAddModalOpen}
                title={`Add ${tenant?.name} to ${selectedProperty?.name}?`}
                message={`Are you sure you want to add ${tenant?.name} to ${selectedProperty?.name}?`}
                onConfirm={onTenantAddSubmit}
                onClose={onTenantAddCancel}
            />
            <ConfirmModal
                isOpen={isConfirmRemoveModalOpen}
                title={`Remove ${tenant?.name} from ${selectedProperty?.name}?`}
                message={`Are you sure you want to remove ${tenant?.name} from ${selectedProperty?.name}?`}
                onConfirm={onTenantRemoveSubmit}
                onClose={closeConfirmRemoveModal}
            />
            <ConfirmModal
                isOpen={isConfirmRemoveCommunicationModalOpen}
                title={'Remove communication?'}
                message={'Are you sure you want to remove this communication?'}
                onConfirm={onCommunicationRemoveSubmit}
                onClose={closeConfirmRemoveCommunicationModal}
            />
            <Breadcrumbs items={breadcrumbs} />
            <PageContainer>
                {isTenantLoading && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}
                {!isTenantLoading && !isTenantError && tenant && (
                    <Stack spacing={1}>
                        <Flex gap={2} alignItems="center">
                            <IconArrowBack
                                size={24}
                                cursor="pointer"
                                onClick={() => navigate('/tenants')}
                            />
                            <Text fontSize="2xl" fontWeight="bold">
                                {tenant.name}
                            </Text>
                        </Flex>
                        <TenantCommunicationList
                            tenant={tenant}
                            onCommunicationAdd={onCommunicationAdd}
                            onCommunicationDelete={onCommunicationDelete}
                        />
                        {isRentsLoading && (
                            <Center>
                                <Spinner size="lg" />
                            </Center>
                        )}
                        {!isRentsLoading && !isRentsError && rents && (
                            <Stack spacing={1}>
                                <Text fontSize="xl">Rents:</Text>
                                {isEmpty(rents) && <Text>No rents found</Text>}
                                {rents.map((rent) => {
                                    return (
                                        <Flex
                                            key={rent.due_date}
                                            gap={2}
                                            alignItems="center">
                                            <Text>
                                                {new Date(
                                                    rent.due_date,
                                                ).toDateString()}
                                            </Text>
                                            <Checkbox
                                                checked={rent.paid}
                                                onChange={() =>
                                                    onRentStatusUpdate(rent)
                                                }
                                            />
                                        </Flex>
                                    );
                                })}
                            </Stack>
                        )}
                        {isRentsLoading && (
                            <Center>
                                <Spinner size="lg" />
                            </Center>
                        )}
                        {!isTenantLoading && !isTenantError && properties && (
                            <Stack spacing={1}>
                                <Text fontSize="xl">Properties:</Text>
                                {isEmpty(properties) && (
                                    <Text>No properties found</Text>
                                )}
                                <Grid templateColumns="repeat(3, 1fr)" gap={6}>
                                    {properties.map((property) => (
                                        <GridItem key={property.id}>
                                            <PropertyCard
                                                property={property}
                                                onDeleteClick={() => {
                                                    setSelectedProperty(
                                                        property,
                                                    );
                                                    openConfirmRemoveModal();
                                                }}
                                            />
                                        </GridItem>
                                    ))}
                                </Grid>
                            </Stack>
                        )}
                        {allProperties && properties && (
                            <Flex gap={2} direction="column">
                                <Text fontSize="xl">Add property:</Text>
                                <Select
                                    placeholder="Properties..."
                                    ref={selectRef}
                                    onChange={(e) => {
                                        setSelectedProperty(
                                            allProperties.find(
                                                (property) =>
                                                    property.id ===
                                                    Number(e.target.value),
                                            ) ?? null,
                                        );

                                        openConfirmAddModal();
                                    }}
                                    isDisabled={
                                        isEmpty(allProperties) ||
                                        selectedProperty !== null
                                    }>
                                    {allProperties.map((property) => (
                                        <option
                                            key={property.id}
                                            value={property.id}
                                            disabled={properties
                                                .map((p) => p.id)
                                                .includes(property.id)}>
                                            {property.name}
                                        </option>
                                    ))}
                                </Select>
                            </Flex>
                        )}
                    </Stack>
                )}
            </PageContainer>
        </Box>
    );
}

export default TenantPage;
