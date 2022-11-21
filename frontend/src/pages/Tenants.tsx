import {
    Box,
    Center,
    Grid,
    GridItem,
    Spinner,
    Stack,
    Text,
} from '@chakra-ui/react';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import useSWR from 'swr';
import { useEffect, useMemo } from 'react';
import { useNotification } from '../hooks/useNotification';
import { TenantList } from '../types/tenant';
import {
    tenantApiService,
    TenantApiService,
} from '../services/api/TenantApiService';
import TenantCard from '../components/Tenant/TenantCard';

function Tenants() {
    const { data, error, isValidating } = useSWR<TenantList>(
        TenantApiService.listTenantsPath,
        tenantApiService.getTenants,
    );
    const { showError } = useNotification();

    const isLoading = useMemo(
        () => data === undefined || (isValidating && error !== undefined),
        [data, isValidating, error],
    );

    const isError = useMemo(() => error !== undefined, [error]);

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
                                    <TenantCard tenant={tenant} />
                                </GridItem>
                            ))}
                    </Grid>
                </Stack>
            </PageContainer>
        </Box>
    );
}

export default Tenants;
