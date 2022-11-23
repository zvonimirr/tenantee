import {
    Box,
    Center,
    Flex,
    Grid,
    GridItem,
    Spinner,
    Stack,
    Text,
    useDisclosure,
} from '@chakra-ui/react';
import { IconArrowBack, IconHome, IconMoneybag } from '@tabler/icons';
import { useCallback, useMemo, useState } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import useSWR from 'swr';
import ConfirmModal from '../components/Modals/ConfirmModal';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import TenantCard from '../components/Tenant/TenantCard';
import { useNotification } from '../hooks/useNotification';
import {
    propertyApiService,
    PropertyApiService,
} from '../services/api/PropertyApiService';
import { PropertyResponse } from '../types/property';
import { Tenant } from '../types/tenant';

function Property() {
    const { id } = useParams();
    const navigate = useNavigate();
    const { showError, showSuccess } = useNotification();

    const { data, error, isValidating, mutate } = useSWR<PropertyResponse>(
        PropertyApiService.getPropertyPath(Number(id)),
        propertyApiService.getProperty,
    );

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, isValidating, error],
    );

    const [selectedTenant, setSelectedTenant] = useState<Tenant | null>(null);

    const {
        isOpen: isConfirmModalOpen,
        onOpen: openConfirmModal,
        onClose: closeConfirmModal,
    } = useDisclosure();

    const isError = useMemo(() => error !== undefined, [error]);
    const property = useMemo(() => data?.property, [data]);
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
                closeConfirmModal();
                mutate();
            }
        }
    }, [selectedTenant, mutate]);

    return (
        <Box>
            <ConfirmModal
                isOpen={isConfirmModalOpen}
                title={`Remove ${selectedTenant?.name} from ${property?.name}?`}
                message={`Are you sure you want to remove ${selectedTenant?.name} from the property?`}
                onConfirm={onTenantRemoveSubmit}
                onCancel={closeConfirmModal}
            />
            <Breadcrumbs items={breadcrumbs} />
            <PageContainer>
                {isLoading && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}
                {!isLoading && !isError && property && (
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
                                        onDeleteClick={(tenant) => {
                                            setSelectedTenant(tenant);
                                            openConfirmModal();
                                        }}
                                    />
                                </GridItem>
                            ))}
                        </Grid>
                    </Stack>
                )}
            </PageContainer>
        </Box>
    );
}

export default Property;
