import {
    Box,
    Center,
    Flex,
    Grid,
    GridItem,
    Select,
    Spinner,
    Stack,
    Text,
    useDisclosure,
} from '@chakra-ui/react';
import { IconArrowBack, IconHome, IconMoneybag } from '@tabler/icons';
import { isEmpty, prop } from 'ramda';
import { useCallback, useMemo, useRef, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import ConfirmModal from '../components/Modals/ConfirmModal';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import TenantCard from '../components/Tenant/TenantCard';
import { useFetch } from '../hooks/useFetch';
import { useNotification } from '../hooks/useNotification';
import {
    propertyApiService,
    PropertyApiService,
} from '../services/api/PropertyApiService';
import {
    tenantApiService,
    TenantApiService,
} from '../services/api/TenantApiService';
import { Property } from '../types/property';
import { Tenant, TenantList } from '../types/tenant';

function PropertyPage() {
    const { id } = useParams();
    const navigate = useNavigate();
    const { showError, showSuccess } = useNotification();

    const onTenantCardClick = useCallback(
        (tenant: Tenant) => navigate(`/tenants/${tenant.id}`),
        [navigate],
    );

    const {
        result: property,
        isError: isPropertyError,
        isLoading: isPropertyLoading,
        mutate,
    } = useFetch<Property, Property>(
        PropertyApiService.getPropertyPath(Number(id)),
        propertyApiService.getProperty,
    );

    const { result: tenants, isLoading: isTenantsLoading } = useFetch<
        TenantList,
        Tenant[]
    >(
        TenantApiService.listTenantsPath(),
        tenantApiService.getTenants,
        'tenants',
    );

    const [selectedTenant, setSelectedTenant] = useState<Tenant | null>(null);

    const selectRef = useRef<HTMLSelectElement>(null);

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

    const tenantOptions = useMemo(() => {
        if (!tenants || !property) {
            return [];
        }

        const tenantIds = property.tenants.map(prop('id'));

        return tenants.filter((tenant) => !tenantIds.includes(tenant.id));
    }, [tenants, property]);

    const breadcrumbs = useMemo(
        () => [
            {
                label: 'Properties',
                href: '/properties',
            },
            {
                label: property?.name,
                href: `/properties/${property?.id}`,
            },
        ],
        [property],
    );

    const onTenantAddSubmit = useCallback(async () => {
        if (property && selectedTenant && selectRef.current) {
            try {
                await propertyApiService.addTenantToProperty(
                    PropertyApiService.addTenantToPropertyPath(
                        property.id,
                        selectedTenant.id,
                    ),
                );

                showSuccess(
                    'Tenant added',
                    `${selectedTenant.name} was added to the property.`,
                );
            } catch (e) {
                showError(
                    'Error',
                    'An error occured while trying to add the tenant to the property.',
                );
            } finally {
                setSelectedTenant(null);
                mutate();
                selectRef.current.value = '';
                closeConfirmAddModal();
            }
        }
    }, [selectedTenant, property, mutate]);

    const onTenantAddCancel = useCallback(() => {
        setSelectedTenant(null);
        closeConfirmAddModal();
    }, []);

    const onTenantRemoveSubmit = useCallback(async () => {
        if (selectedTenant) {
            try {
                await propertyApiService.removeTenantFromProperty(
                    PropertyApiService.removeTenantFromPropertyPath(
                        Number(id),
                        selectedTenant.id,
                    ),
                );

                showSuccess(
                    'Tenant removed',
                    `${selectedTenant.name} was removed from the property`,
                );
            } catch (e) {
                showError(
                    'Error',
                    'An error occurred while trying to remove the tenant from the property',
                );
            } finally {
                setSelectedTenant(null);
                closeConfirmRemoveModal();
                mutate();
            }
        }
    }, [selectedTenant, mutate]);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmAddModalOpen}
                title={`Add ${selectedTenant?.name} to ${property?.name}?`}
                message={`Are you sure you want to add ${selectedTenant?.name} to ${property?.name}?`}
                onConfirm={onTenantAddSubmit}
                onCancel={onTenantAddCancel}
            />
            <ConfirmModal
                isOpen={isConfirmRemoveModalOpen}
                title={`Remove ${selectedTenant?.name} from ${property?.name}?`}
                message={`Are you sure you want to remove ${selectedTenant?.name} from the property?`}
                onConfirm={onTenantRemoveSubmit}
                onCancel={closeConfirmRemoveModal}
            />
            <Breadcrumbs items={breadcrumbs} />
            <PageContainer>
                {isPropertyLoading && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}
                {!isPropertyError && !isPropertyError && property && (
                    <Stack spacing={1}>
                        <Flex gap={2} alignItems="center">
                            <IconArrowBack
                                size={24}
                                cursor="pointer"
                                onClick={() => navigate('/properties')}
                            />
                            <Text fontSize="2xl" fontWeight="bold">
                                {property.name}
                            </Text>
                        </Flex>
                        <Flex gap={2} alignItems="center">
                            <IconHome size={20} />
                            <Text>{property.location}</Text>
                        </Flex>
                        <Text>{property.description}</Text>
                        <Flex gap={2} alignItems="center">
                            <IconMoneybag size={20} />
                            <Text>
                                {property.price.amount}{' '}
                                {property.price.currency}
                            </Text>
                        </Flex>
                        <Grid templateColumns="repeat(3, 1fr)" gap={6}>
                            {property.tenants.map((tenant) => (
                                <GridItem key={tenant.id}>
                                    <TenantCard
                                        tenant={tenant}
                                        onClick={onTenantCardClick}
                                        onDeleteClick={(tenant) => {
                                            setSelectedTenant(tenant);
                                            openConfirmRemoveModal();
                                        }}
                                    />
                                </GridItem>
                            ))}
                        </Grid>
                        <Flex gap={2} direction="column">
                            <Text fontWeight="bold">Add tenants</Text>
                            <Select
                                placeholder="Tenants..."
                                ref={selectRef}
                                onChange={(e) => {
                                    setSelectedTenant(
                                        tenantOptions.find(
                                            (t) =>
                                                t.id === Number(e.target.value),
                                        ) as Tenant,
                                    );
                                    openConfirmAddModal();
                                }}
                                isDisabled={
                                    isTenantsLoading ||
                                    isEmpty(tenantOptions) ||
                                    selectedTenant !== null
                                }>
                                {tenantOptions.map((tenant) => (
                                    <option key={tenant.id} value={tenant.id}>
                                        {tenant.name}
                                    </option>
                                ))}
                            </Select>
                        </Flex>
                    </Stack>
                )}
            </PageContainer>
        </Box>
    );
}

export default PropertyPage;
