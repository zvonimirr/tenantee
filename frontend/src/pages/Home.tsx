import { Box } from '@chakra-ui/react';
import Breadcrumbs from '../components/Navigation/Breadcrumbs';
import PageContainer from '../components/PageContainer';

function Home() {
    return (
        <Box>
            <Breadcrumbs items={[]} />
            <PageContainer>Homepage.</PageContainer>
        </Box>
    );
}

export default Home;
