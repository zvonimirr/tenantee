import { Box, Center, Spinner, Text } from '@chakra-ui/react';
import useSWR from 'swr';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';
import {
    preferenceApiService,
    PreferenceApiService,
} from '../services/api/PreferenceApiService';
import { Preference } from '../types/preferences';

function Home() {
    const { data, isValidating } = useSWR<Preference>(
        PreferenceApiService.getByNamePath('name'),
        preferenceApiService.getPreference,
    );

    return (
        <Box>
            <Breadcrumbs items={[]} />
            <PageContainer>
                {isValidating && (
                    <Center>
                        <Spinner size="lg" />
                    </Center>
                )}
                {!isValidating && (
                    <Text fontSize="xl">
                        Hello,{' '}
                        <span style={{ fontWeight: 'bold' }}>
                            {data?.value ?? 'landlord'}
                        </span>
                        !
                    </Text>
                )}
            </PageContainer>
        </Box>
    );
}

export default Home;
