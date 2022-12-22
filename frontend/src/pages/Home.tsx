import { Box, Center, Spinner, Text } from '@chakra-ui/react';
import { isEmpty } from 'ramda';
import { useMemo } from 'react';
import { Link } from 'react-router-dom';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import { useFetch } from '../hooks/useFetch';
import { preferenceApiService } from '../services/api/PreferenceApiService';
import { propertyApiService } from '../services/api/PropertyApiService';

function Home() {
    const { 
        data: { value: preference } = { value: '' },
        isLoading
    } = useFetch(
        [preferenceApiService.apiRoute, 'default_currency'],
        preferenceApiService.get
    );

    const { 
        data: { properties } = { properties: [] },
        isLoading: isLoadingProperties 
    } = useFetch(
        [propertyApiService.apiRoute],
        propertyApiService.list
    );

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
                {isLoading ||
                    (isLoadingProperties && (
                        <Center>
                            <Spinner size="lg" />
                        </Center>
                    ))}
                {!isLoading && (
                    <Text fontSize="xl">
                        Hello,{' '}
                        <span style={{ fontWeight: 'bold' }}>
                            {preference ?? 'landlord'}
                        </span>
                        !
                    </Text>
                )}
                {!isLoading && properties && isEmpty(properties) && (
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
                )}
                {!isLoadingProperties && properties && !isEmpty(properties) && (
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
                                ~{monthlyRevenue}
                            </span>{' '}
                            {properties[0].monthly_revenue.currency}.
                        </Text>
                    </Box>
                )}
            </PageContainer>
        </Box>
    );
}

export default Home;
