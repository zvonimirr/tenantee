import {
    Box,
    Center,
    Checkbox,
    Flex,
    Spinner,
    Stack,
    Text,
} from '@chakra-ui/react';
import { IconArrowBack } from '@tabler/icons';
import { useCallback, useMemo } from 'react';
import { useNavigate, useParams } from 'react-router-dom';
import useSWR from 'swr';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import { useNotification } from '../hooks/useNotification';
import { rentApiService, RentApiService } from '../services/api/RentApiService';
import {
    tenantApiService,
    TenantApiService,
} from '../services/api/TenantApiService';
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
        data: rentData,
        error: rentError,
        isValidating: isValidatingRent,
        mutate: mutateRents,
    } = useSWR<RentList>(
        tenant ? RentApiService.getRentsByTenantIdPath(tenant.id) : null,
        rentApiService.getRents,
    );

    const isLoadingRents = useMemo(
        () =>
            rentData === undefined ||
            (isValidatingRent && rentError !== undefined),
        [rentData, isValidatingRent, rentError],
    );
    const isRentError = useMemo(() => rentError !== undefined, [rentError]);
    const rents = useMemo(() => rentData?.rents, [rentData]);

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

    return (
        <Box>
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
                                {rents.length === 0 && (
                                    <Text>No rents found</Text>
                                )}
                                {rents.length > 0 &&
                                    rents.map((rent) => {
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
                    </Stack>
                )}
            </PageContainer>
        </Box>
    );
}

export default TenantPage;
