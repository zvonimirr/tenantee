import { Box, Center, Spinner, Text } from '@chakra-ui/react';
import { isEmpty } from 'ramda';
import { useMemo } from 'react';
import { Link } from 'react-router-dom';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import { useFetch } from '../hooks/useFetch';
import { preferenceApiService } from '../services/api/PreferenceApiService';
import { propertyApiService } from '../services/api/PropertyApiService';
import { formatMoney } from '../utils/money';

function Home() {
    const {
        data: { value: name } = { value: 'landlord' },
        isLoading: isLoadingName,
    } = useFetch(
        [preferenceApiService.apiRoute, 'name'],
        preferenceApiService.get,
    );

    const {
        data: { properties } = { properties: [] },
        isLoading: isLoadingProperties,
    } = useFetch([propertyApiService.apiRoute], propertyApiService.list);

    const isLoading = isLoadingName || isLoadingProperties;

    const monthlyRevenue = useMemo(() => {
        if (isEmpty(properties) || !properties) {
            return 0;
        }

        return properties
            .map((p) => Number(p.monthly_revenue.amount))
            .reduce((a, b) => a + b, 0);
    }, [properties]);

    return (
        <Box>
            <Breadcrumbs items={[]} />
            <PageContainer>
                {isLoading && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}

                {!isLoading && (
                    <>
                        <Text fontSize="xl">
                            Hello,{' '}
                            <span style={{ fontWeight: 'bold' }}>
                                {name ?? 'landlord'}
                            </span>
                            !
                        </Text>
                        {!properties.length && (
                            <Text fontSize="xl">
                                {"You don't have any properties yet. "}
                                <span
                                    style={{
                                        fontWeight: 'bold',
                                        textDecoration: 'underline',
                                    }}>
                                    <Link to="/properties">Add one now</Link>.
                                </span>
                            </Text>
                        )}
                        {properties.length && (
                            <Box>
                                <Text fontSize="xl">
                                    You have{' '}
                                    <span style={{ fontWeight: 'bold' }}>
                                        {properties.length}
                                    </span>{' '}
                                    {properties.length === 1
                                        ? 'property'
                                        : 'properties'}
                                    .
                                </Text>
                                <Text fontSize="xl">
                                    Your monthly revenue is{' '}
                                    <span style={{ fontWeight: 'bold' }}>
                                        ~
                                        {formatMoney(
                                            monthlyRevenue,
                                            properties[0].monthly_revenue
                                                .currency,
                                        )}
                                    </span>
                                </Text>
                            </Box>
                        )}
                    </>
                )}
            </PageContainer>
        </Box>
    );
}

export default Home;
