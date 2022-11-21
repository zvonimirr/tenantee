import { Box, Flex } from '@chakra-ui/react';
import { ReactNode } from 'react';

interface LabelProps {
    icon: ReactNode;
    label: string;
}

function Label({ icon, label }: LabelProps) {
    return (
        <Flex direction="row">
            {icon}
            <Box ml="8px">{label}</Box>
        </Flex>
    );
}

export default Label;
