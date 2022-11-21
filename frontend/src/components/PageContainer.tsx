import { Box } from '@chakra-ui/react';
import { ReactNode } from 'react';

interface PageContainerProps {
    children: ReactNode;
}

function PageContainer({ children }: PageContainerProps) {
    return <Box p={4}>{children}</Box>;
}

export default PageContainer;
