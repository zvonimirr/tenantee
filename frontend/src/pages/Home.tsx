import { Box, Center, Spinner, Text } from '@chakra-ui/react';
import { isEmpty } from 'ramda';
import { useMemo } from 'react';
import { Link } from 'react-router-dom';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import { useFetch } from '../hooks/useFetch';
import { preferenceApiService } from '../services/api/PreferenceApiService';
import { propertyApiService } from '../services/api/PropertyApiService';
import { pluralize } from '../utils/common';
import { formatMoney } from '../utils/money';
import { getPreferenceValueByName } from '../utils/preferences';

function Home() {
    const {
        data: { preferences } = { preferences: [] },
        isLoading: isLoadingPreferences,
    } = useFetch([preferenceApiService.apiRoute], preferenceApiService.list);

    const {
        data: { properties } = { properties: [] },
        isLoading: isLoadingProperties,
    } = useFetch([propertyApiService.apiRoute], propertyApiService.list);

    const isLoading = isLoadingPreferences || isLoadingProperties;

    const name = useMemo(() => {
        return getPreferenceValueByName(preferences, 'name', 'landlord');
    }, [preferences]);

    const currency = useMemo(() => {
        return getPreferenceValueByName(preferences, 'default_currency', 'USD');
    }, [preferences]);

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
                        {properties.length < 1 ? (
                            <Text fontSize="xl">
                                {'You don\'t have any properties yet. '}
                                <span
                                    style={{
                                        fontWeight: 'bold',
                                        textDecoration: 'underline',
                                    }}>
                                    <Link to="/properties">Add one now</Link>.
                                </span>
                            </Text>
                        ) : (
                            <Box>
                                <Text fontSize="xl">
                                    You have{' '}
                                    <span style={{ fontWeight: 'bold' }}>
                                        {properties.length}
                                    </span>{' '}
                                    {pluralize(
                                        properties,
                                        'property',
                                        'properties',
                                    )}
                                    .
                                </Text>
                                <Text fontSize="xl">
                                    Your monthly revenue is{' '}
                                    <span style={{ fontWeight: 'bold' }}>
                                        ~{formatMoney(monthlyRevenue, currency)}
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
