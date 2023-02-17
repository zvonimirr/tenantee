import { Button, Flex, Stack, Text } from '@chakra-ui/react';
import {
    IconBrandFacebook,
    IconBrandInstagram,
    IconBrandTelegram,
    IconBrandWhatsapp,
    IconMail,
    IconPhone,
    IconTrash,
} from '@tabler/icons-react';
import { isEmpty } from 'ramda';
import { useMemo } from 'react';
import { useForm } from 'react-hook-form';
import { Communication, Tenant } from '../../types/tenant';
import GenericInput from '../Form/GenericInput';

interface TenantCommunicationListProps {
    tenant: Tenant;
    withoutTitle?: boolean;
    onCommunicationAdd?: (
        communication: Omit<Communication, 'id'>,
    ) => Promise<void>;
    onCommunicationDelete?: (id: string) => void;
}

// TODO: Figure out a better way to do this
const TYPE_TO_ICON = {
    mail: <IconMail />,
    email: <IconMail />,
    phone: <IconPhone />,
    fb: <IconBrandFacebook />,
    messenger: <IconBrandFacebook />,
    facebook: <IconBrandFacebook />,
    ig: <IconBrandInstagram />,
    insta: <IconBrandInstagram />,
    instagram: <IconBrandInstagram />,
    telegram: <IconBrandTelegram />,
    wa: <IconBrandWhatsapp />,
    whatsapp: <IconBrandWhatsapp />,
} as Record<string, JSX.Element>;

function TenantCommunicationList({
    tenant,
    withoutTitle = false,
    onCommunicationAdd,
    onCommunicationDelete,
}: TenantCommunicationListProps) {
    const { control, reset, handleSubmit, formState } = useForm<
        Pick<Communication, 'type' | 'value'>
    >({
        mode: 'onChange',
        defaultValues: {
            type: '',
            value: '',
        },
    });
    const communications = useMemo(() => tenant.communications, [tenant]);

    return (
        <Flex gap={2} direction="column">
            {!withoutTitle && <Text fontSize="xl">Communication:</Text>}
            {isEmpty(communications) && <Text>No communications found.</Text>}
            {communications?.map((communication) => {
                const type = TYPE_TO_ICON[communication.type.toLowerCase()] ?? (
                    <Text>{communication.type}</Text>
                );

                return (
                    <Flex key={communication.id} gap={2} alignItems="center">
                        <Text>
                            <Flex alignItems="center" gap={2}>
                                {type}
                                <Text>{communication.value}</Text>
                            </Flex>
                        </Text>
                        {onCommunicationDelete && (
                            <IconTrash
                                color="red"
                                cursor="pointer"
                                onClick={() =>
                                    onCommunicationDelete(communication.id)
                                }
                            />
                        )}
                    </Flex>
                );
            })}
            {onCommunicationAdd && (
                <Stack>
                    <GenericInput
                        name="type"
                        label="Type"
                        control={control}
                        disabled={formState.isSubmitting}
                        rules={{ required: 'Type is required' }}
                        placeholder="Communication type..."
                    />
                    <GenericInput
                        name="value"
                        label="Value"
                        control={control}
                        disabled={formState.isSubmitting}
                        rules={{ required: 'Value is required' }}
                        placeholder="Communication value..."
                    />
                    <Button
                        colorScheme="teal"
                        isLoading={formState.isSubmitting}
                        isDisabled={
                            formState.isSubmitting || !formState.isValid
                        }
                        onClick={handleSubmit(async (data) => {
                            await onCommunicationAdd(data);
                            reset();
                        })}>
                        Add Communication
                    </Button>
                </Stack>
            )}
        </Flex>
    );
}

export default TenantCommunicationList;
