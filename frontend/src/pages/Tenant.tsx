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
import { IconArrowBack } from '@tabler/icons';
import { isEmpty } from 'ramda';
import { useCallback, useMemo, useRef, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import useSWR from 'swr';
import ConfirmModal from '../components/Modals/ConfirmModal';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import PropertyCard from '../components/Property/PropertyCard';
import { useNotification } from '../hooks/useNotification';
import {
    PropertyApiService,
    propertyApiService,
} from '../services/api/PropertyApiService';
import { rentApiService, RentApiService } from '../services/api/RentApiService';
import {
    tenantApiService,
    TenantApiService,
} from '../services/api/TenantApiService';
import { Property, PropertyList } from '../types/property';
import { Rent, RentList } from '../types/rent';
import { Tenant } from '../types/tenant';

function TenantPage() {
    const { id } = useParams();
    const navigate = useNavigate();
    const { showError, showSuccess } = useNotification();

    const {
        data: tenant,
        error: tenantError,
        isValidating: isValidatingTenant,
        mutate: mutateTenant,
    } = useSWR<Tenant>(
        TenantApiService.getTenantPath(Number(id)),
        tenantApiService.getTenant,
    );

    const isLoadingTenant = useMemo(
        () =>
            tenant === undefined ||
            (isValidatingTenant && tenantError !== undefined),
        [tenant, isValidatingTenant, tenantError],
    );
    const isTenantError = useMemo(
        () => tenantError !== undefined,
        [tenantError],
    );

    const {
        data: allPropertiesData,
        error: allPropertiesError,
        isValidating: isValidatingAllProperties,
    } = useSWR<PropertyList>(
        PropertyApiService.listPropertiesPath,
        propertyApiService.getProperties,
    );

    const allProperties = useMemo(
        () => allPropertiesData?.properties,
        [allPropertiesData],
    );
    const isAllPropertiesError = useMemo(
        () => allPropertiesError !== undefined,
        [allPropertiesError],
    );
    const isLoadingAllProperties = useMemo(
        () =>
            allProperties !== undefined ||
            (isValidatingAllProperties && isAllPropertiesError),
        [allProperties, isValidatingAllProperties, isAllPropertiesError],
    );

    const {
        data: rentData,
        error: rentError,
        isValidating: isValidatingRent,
        mutate: mutateRents,
    } = useSWR<RentList>(
        tenant ? RentApiService.getRentsByTenantIdPath(tenant.id) : null,
        rentApiService.getRents,
    );

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

    const isLoadingRents = useMemo(
        () =>
            rentData === undefined ||
            (isValidatingRent && rentError !== undefined),
        [rentData, isValidatingRent, rentError],
    );
    const isRentError = useMemo(() => rentError !== undefined, [rentError]);
    const rents = useMemo(() => rentData?.rents, [rentData]);
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

    const onRentStatusUpdate = useCallback(async (rent: Rent) => {
        try {
            await rentApiService.updateRent(
                RentApiService.markRentPath(rent.id, !rent.paid),
            );
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
    }, []);

    const onTenantAddSubmit = useCallback(async () => {
        if (tenant && selectedProperty && selectRef.current) {
            try {
                await propertyApiService.addTenantToProperty(
                    PropertyApiService.addTenantToPropertyPath(
                        selectedProperty.id,
                        tenant.id,
                    ),
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
    }, [tenant, selectedProperty]);

    const onTenantRemoveSubmit = useCallback(async () => {
        if (selectedProperty && tenant) {
            try {
                await propertyApiService.removeTenantFromProperty(
                    PropertyApiService.removeTenantFromPropertyPath(
                        selectedProperty.id,
                        tenant.id,
                    ),
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
    }, [tenant, selectedProperty]);

    const onTenantAddCancel = useCallback(() => {
        setSelectedProperty(null);
        closeConfirmAddModal();
    }, []);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmAddModalOpen}
                title={`Add ${tenant?.name} to ${selectedProperty?.name}?`}
                message={`Are you sure you want to add ${tenant?.name} to ${selectedProperty?.name}?`}
                onConfirm={onTenantAddSubmit}
                onCancel={onTenantAddCancel}
            />
            <ConfirmModal
                isOpen={isConfirmRemoveModalOpen}
                title={`Remove ${tenant?.name} from ${selectedProperty?.name}?`}
                message={`Are you sure you want to remove ${tenant?.name} from ${selectedProperty?.name}?`}
                onConfirm={onTenantRemoveSubmit}
                onCancel={closeConfirmRemoveModal}
            />
            <Breadcrumbs items={breadcrumbs} />
            <PageContainer>
                {isLoadingTenant && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}
                {!isLoadingTenant && !isTenantError && tenant && (
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
                        {isLoadingRents && (
                            <Center>
                                <Spinner size="lg" />
                            </Center>
                        )}
                        {!isLoadingRents && !isRentError && rents && (
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
                        {isLoadingTenant && (
                            <Center>
                                <Spinner size="lg" />
                            </Center>
                        )}
                        {!isLoadingTenant && !isTenantError && properties && (
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
