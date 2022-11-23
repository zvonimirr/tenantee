import {
    Box,
    Button,
    FormControl,
    Modal,
    ModalBody,
    ModalCloseButton,
    ModalContent,
    ModalHeader,
    ModalOverlay,
    Stack,
} from '@chakra-ui/react';
import { IconPencil, IconPhone } from '@tabler/icons';
import { useEffect } from 'react';
import { useForm } from 'react-hook-form';
import { Tenant, TenantUpdateDto } from '../../../types/tenant';
import GenericInput from '../../Form/GenericInput';

interface EditTenantModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSubmit: (property: TenantUpdateDto) => void;
    tenant: Tenant | null;
}

const defaultValues = {
    name: '',
    email: '',
    phone: '',
};

function EditTenantModal({
    isOpen,
    onClose,
    onSubmit,
    tenant,
}: EditTenantModalProps) {
    const { handleSubmit, formState, control, reset } = useForm({
        mode: 'onChange',
        defaultValues,
    });

    useEffect(() => {
        if (tenant) {
            reset({
                name: tenant.name,
                email: tenant.email,
                phone: tenant.phone
            });
        }
    }, [tenant]);

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Update {tenant?.name}</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <FormControl>
                        <Stack spacing={4}>
                            <GenericInput
                                name="name"
                                label="Name"
                                placeholder="Name of the tenant"
                                control={control}
                                rules={{
                                    required: 'Name is required',
                                }}
                                leftAdornment={<IconPencil />}
                            />
                            <GenericInput
                                name="email"
                                label="Email"
                                placeholder="Email of the tenant (optional)"
                                control={control}
                            />
                            <GenericInput
                                name="phone"
                                label="Phone"
                                placeholder="Phone of the tenant (optional)"
                                control={control}
                                leftAdornment={<IconPhone />}
                            />
                            <Box w="100%">
                                <Button
                                    w="100%"
                                    colorScheme="teal"
                                    disabled={
                                        !formState.isValid ||
                                        formState.isSubmitting ||
                                        tenant === null
                                    }
                                    onClick={handleSubmit((values) =>
                                        onSubmit({
                                            id: tenant?.id ?? 0,
                                            tenant: {
                                                ...values,
                                                first_name: values.name.split(' ')[0],
                                                last_name: values.name.split(' ')[1]
                                            },
                                        }),
                                    )}>
                                    Update Property
                                </Button>
                            </Box>
                        </Stack>
                    </FormControl>
                </ModalBody>
            </ModalContent>
        </Modal>
    );
}

export default EditTenantModal;
