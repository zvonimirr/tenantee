import { Card, CardBody, Center, Flex, Stack, Text } from '@chakra-ui/react';
import { IconTrash, IconUser } from '@tabler/icons';
import { Tenant } from '../../types/tenant';

interface TenantCardProps {
    tenant: Tenant;
    onDeleteClick: (tenant: Tenant) => void;
}

function TenantCard({ tenant, onDeleteClick }: TenantCardProps) {
    return (
        <Card>
            <CardBody>
                <IconTrash
                    color="red"
                    cursor="pointer"
                    onClick={() => onDeleteClick(tenant)}
                />
                <Center>
                    <Flex direction="column">
                        <IconUser size={128} />
                        <Stack spacing={2}>
                            <Text>{tenant.name}</Text>
                        </Stack>
                    </Flex>
                </Center>
            </CardBody>
        </Card>
    );
}

export default TenantCard;
