import { Box, Center, Spinner, Text } from '@chakra-ui/react';
import { isEmpty } from 'ramda';
import { useMemo } from 'react';
import { Link } from 'react-router-dom';
import useSWR from 'swr';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import {
    preferenceApiService,
    PreferenceApiService,
} from '../services/api/PreferenceApiService';
import {
    propertyApiService,
    PropertyApiService,
} from '../services/api/PropertyApiService';
import { Preference } from '../types/preferences';
import { PropertyList } from '../types/property';

function Home() {
    const { data, isValidating } = useSWR<Preference>(
        PreferenceApiService.getByNamePath('name'),
        preferenceApiService.getPreference,
    );

    const { data: propertyData, isValidating: isValidatingProperties } =
        useSWR<PropertyList>(
            PropertyApiService.listPropertiesPath,
            propertyApiService.getProperties,
        );

    const properties = useMemo(() => propertyData?.properties, [propertyData]);
    const monthlyRevenue = useMemo(
        () =>
            properties
                ?.map((p) => Number(p.monthly_revenue.amount))
                .reduce((a, b) => a + b, 0),
        [properties],
    );

    return (
        <Box>
            <Breadcrumbs items={[]} />
            <PageContainer>
                {isValidating ||
                    (isValidatingProperties && (
                        <Center>
                            <Spinner size="lg" />
                        </Center>
                    ))}
                {!isValidating && (
                    <Text fontSize="xl">
                        Hello,{' '}
                        <span style={{ fontWeight: 'bold' }}>
                            {data?.value ?? 'landlord'}
                        </span>
                        !
                    </Text>
                )}
                {!isValidating && properties && isEmpty(properties) && (
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
                {!isValidatingProperties &&
                    properties &&
                    !isEmpty(properties) && (
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
