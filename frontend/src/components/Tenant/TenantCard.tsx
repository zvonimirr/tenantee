import {
    Box,
    Card,
    CardBody,
    Center,
    Flex,
    Stack,
    Text,
    useDisclosure,
} from '@chakra-ui/react';
import { IconDots, IconPencil, IconTrash, IconUser } from '@tabler/icons-react';
import { useMemo } from 'react';
import { Tenant } from '../../types/tenant';
import BaseModal from '../Modals/BaseModal';
import TenantCommunicationList from './TenantCommunicationList';

interface TenantCardProps {
    tenant: Tenant;
    onClick: (tenant: Tenant) => void;
    onDeleteClick: (tenant: Tenant) => void;
    onEditClick?: (tenant: Tenant) => void;
}

function TenantCard({
    tenant,
    onClick,
    onDeleteClick,
    onEditClick,
}: TenantCardProps) {
    const {
        isOpen: isCommunicationsOpen,
        onOpen: onCommunicationsOpen,
        onClose: onCommunicationsClose,
    } = useDisclosure();

    const iconColor = useMemo(() => {
        if (tenant.unpaid_rents.length < 1) {
            return 'black';
        }
        const dates = tenant.unpaid_rents.map(
            (rent) => new Date(rent.due_date),
        );
        const hasDatesInFuture = dates.some((date) => date > new Date());

        return hasDatesInFuture ? '#FFE800' : 'red';
    }, [tenant.unpaid_rents]);

    const rentStatus = useMemo(() => {
        if (tenant.unpaid_rents.length < 1) {
            return null;
        }
        const dates = tenant.unpaid_rents.map(
            (rent) => new Date(rent.due_date),
        );
        const hasDatesInPast = dates.some((date) => date < new Date());

        return hasDatesInPast ? 'Has overdue rent' : 'Has due rent';
    }, [tenant.unpaid_rents]);

    return (
        <Card>
            <BaseModal
                isOpen={isCommunicationsOpen}
                onClose={onCommunicationsClose}
                title="Communications">
                <Box mb={4}>
                    <TenantCommunicationList tenant={tenant} withoutTitle />
                </Box>
            </BaseModal>
            <CardBody>
                <Flex gap={2} justifyContent="space-between">
                    <Flex gap={2}>
                        <IconTrash
                            color="red"
                            cursor="pointer"
                            onClick={() => onDeleteClick(tenant)}
                        />
                        {onEditClick && (
                            <IconPencil
                                cursor="pointer"
                                onClick={() => onEditClick(tenant)}
                            />
                        )}
                    </Flex>
                    {tenant.communications.length > 0 && (
                        <abbr title="Communications">
                            <IconDots
                                cursor="pointer"
                                onClick={onCommunicationsOpen}
                            />
                        </abbr>
                    )}
                </Flex>
                <Center cursor="pointer" onClick={() => onClick(tenant)}>
                    <Flex direction="column" alignItems="center">
                        <IconUser size={128} color={iconColor} />
                        <Stack spacing={2}>
                            <Text textAlign="center" fontWeight="bold">
                                {tenant.name}
                            </Text>
                            {rentStatus && (
                                <Text textAlign="center">{rentStatus}</Text>
                            )}
                        </Stack>
                    </Flex>
                </Center>
            </CardBody>
        </Card>
    );
}

export default TenantCard;
