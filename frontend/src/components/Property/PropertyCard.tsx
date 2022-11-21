import { Card, CardBody, Center, Flex, Stack, Text } from '@chakra-ui/react';
import { Property } from '../../types/property';
import { IconHome, IconTrash } from '@tabler/icons';

interface PropertyCardProps {
    property: Property;
    onClick: (property: Property) => void;
    onDeleteClick: (property: Property) => void;
}

function PropertyCard({ property, onClick, onDeleteClick }: PropertyCardProps) {
    return (
        <Card>
            <CardBody>
                <IconTrash
                    color="red"
                    cursor="pointer"
                    onClick={() => onDeleteClick(property)}
                />

                <Center cursor="pointer" onClick={() => onClick(property)}>
                    <Flex direction="column">
                        <IconHome size={128} />
                        <Stack spacing={2}>
                            <Text align="center" fontWeight="bold">
                                {property.name}{' '}
                            </Text>
                        </Stack>
                    </Flex>
                </Center>
            </CardBody>
        </Card>
    );
}

export default PropertyCard;
