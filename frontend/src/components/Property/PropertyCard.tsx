import { Card, CardBody, Center, Flex, Stack, Text } from '@chakra-ui/react';
import { Property } from '../../types/property';
import { IconHome, IconPencil, IconTrash } from '@tabler/icons';
interface PropertyCardProps {
    property: Property;
    onClick: (property: Property) => void;
    onDeleteClick: (property: Property) => void;
    onEditClick: (property: Property) => void;
}

function PropertyCard({
    property,
    onClick,
    onDeleteClick,
    onEditClick,
}: PropertyCardProps) {
    return (
        <Card>
            <CardBody>
                <Flex gap={2}>
                    <IconTrash
                        color="red"
                        cursor="pointer"
                        onClick={() => onDeleteClick(property)}
                    />
                    <IconPencil
                        cursor="pointer"
                        onClick={() => onEditClick(property)}
                    />
                </Flex>
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
