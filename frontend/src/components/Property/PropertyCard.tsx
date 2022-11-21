import { Card, CardBody, Center, Stack, Text } from '@chakra-ui/react';
import { Property } from '../../types/property';
import { IconHome } from '@tabler/icons';

interface PropertyCardProps {
    property: Property;
    onClick: (property: Property) => void;
}

function PropertyCard({ property, onClick }: PropertyCardProps) {
    return (
        <Card cursor="pointer" onClick={() => onClick(property)}>
            <CardBody>
                <Center>
                    <Stack spacing={2}>
                        <IconHome size={128} />
                        <Text align="center" fontWeight="bold">
                            {property.name}
                        </Text>
                    </Stack>
                </Center>
            </CardBody>
        </Card>
    );
}

export default PropertyCard;
