import {
    Box,
    Center,
    Flex,
    Grid,
    GridItem,
    Spinner,
    Stack,
    Text,
} from '@chakra-ui/react';
import { IconArrowBack, IconHome, IconMoneybag } from '@tabler/icons';
import { useMemo } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import useSWR from 'swr';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import TenantCard from '../components/Tenant/TenantCard';
import {
    propertyApiService,
    PropertyApiService,
} from '../services/api/PropertyApiService';
import { PropertyResponse } from '../types/property';

function Property() {
    const { id } = useParams();
    const navigate = useNavigate();

    const { data, error, isValidating } = useSWR<PropertyResponse>(
        PropertyApiService.getPropertyPath(Number(id)),
        propertyApiService.getProperty,
    );

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, isValidating, error],
    );

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

    return (
        <Box>
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
                                    <TenantCard tenant={tenant} />
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
