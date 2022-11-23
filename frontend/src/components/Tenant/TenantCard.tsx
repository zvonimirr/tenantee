import { Card, CardBody, Center, Flex, Stack, Text } from '@chakra-ui/react';
import { IconPencil, IconTrash, IconUser } from '@tabler/icons';
import { Tenant } from '../../types/tenant';

interface TenantCardProps {
    tenant: Tenant;
    onDeleteClick: (tenant: Tenant) => void;
    onEditClick?: (tenant: Tenant) => void;
}

function TenantCard({ tenant, onDeleteClick, onEditClick }: TenantCardProps) {
    return (
        <Card>
            <CardBody>
                <Flex gap={2}>
                    <IconTrash
                        color="red"
                        cursor="pointer"
                        onClick={() => onDeleteClick(tenant)}
                    />
                    {onEditClick &&
                        <IconPencil
                            cursor="pointer"
                            onClick={() => onEditClick(tenant)}
                        />}
                </Flex>
                <Center>
                    <Flex direction="column">
                        <IconUser size={128} />
                        <Stack spacing={2}>
                            <Text textAlign="center" fontWeight="bold">
                                {tenant.name}
                            </Text>
                        </Stack>
                    </Flex>
                </Center>
            </CardBody>
        </Card>
    );
}

export default TenantCard;
