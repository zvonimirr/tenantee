import { Button, Flex, Link, Stack, Text } from '@chakra-ui/react';
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

enum CommunicationType {
    PHONE = 'phone',
    MAIL = 'mail',
    WHATSAPP = 'whatsapp',
    TELEGRAM = 'telegram',
    INSTAGRAM = 'instagram',
    FACEBOOK = 'facebook',
}

const STRING_TYPE_TO_ENUM: Record<string, CommunicationType> = {
    mail: CommunicationType.MAIL,
    email: CommunicationType.MAIL,
    phone: CommunicationType.PHONE,
    fb: CommunicationType.FACEBOOK,
    messenger: CommunicationType.FACEBOOK,
    facebook: CommunicationType.FACEBOOK,
    ig: CommunicationType.INSTAGRAM,
    insta: CommunicationType.INSTAGRAM,
    instagram: CommunicationType.INSTAGRAM,
    telegram: CommunicationType.TELEGRAM,
    wa: CommunicationType.WHATSAPP,
    whatsapp: CommunicationType.WHATSAPP,
};

// TODO: Figure out a better way to do this
const TYPE_TO_ICON: Record<CommunicationType, JSX.Element> = {
    [CommunicationType.MAIL]: <IconMail />,
    [CommunicationType.PHONE]: <IconPhone />,
    [CommunicationType.FACEBOOK]: <IconBrandFacebook />,
    [CommunicationType.INSTAGRAM]: <IconBrandInstagram />,
    [CommunicationType.TELEGRAM]: <IconBrandTelegram />,
    [CommunicationType.WHATSAPP]: <IconBrandWhatsapp />,
};

function getUrl(type: CommunicationType, value: string) {
    switch (type) {
    case CommunicationType.MAIL:
        return `mailto:${value}`;
    case CommunicationType.PHONE:
        return `tel:${value}`;
    case CommunicationType.FACEBOOK:
        return `https://www.facebook.com/${value}`;
    case CommunicationType.INSTAGRAM:
        return `https://www.instagram.com/${value}`;
    case CommunicationType.TELEGRAM:
        return `https://t.me/${value}`;
    case CommunicationType.WHATSAPP:
        return `https://wa.me/${value}`;
    default:
        return null;
    }
}

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
                const type =
                    STRING_TYPE_TO_ENUM[communication.type.toLowerCase()] ??
                    null;

                const icon = type ? (
                    TYPE_TO_ICON[type]
                ) : (
                    <Text>{communication.type}</Text>
                );

                const url = getUrl(type, communication.value);

                return (
                    <Flex key={communication.id} gap={2} alignItems="center">
                        <Text>
                            <Flex alignItems="center" gap={2}>
                                {icon}
                                {url ? (
                                    <Link href={url}>
                                        {communication.value}
                                    </Link>
                                ) : (
                                    <Text>{communication.value}</Text>
                                )}
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
