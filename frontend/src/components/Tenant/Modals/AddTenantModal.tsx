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
import { useForm } from 'react-hook-form';
import { TenantDto } from '../../../types/tenant';
import GenericInput from '../../Form/GenericInput';

interface AddTenantModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSubmit: (tenant: TenantDto) => void;
}

const defaultValues = {
    first_name: '',
    last_name: '',
};

function AddTenantModal({ isOpen, onClose, onSubmit }: AddTenantModalProps) {
    const { handleSubmit, formState, control } = useForm({
        mode: 'onChange',
        defaultValues,
    });

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Add New Tenant</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <FormControl>
                        <Stack spacing={4}>
                            <GenericInput
                                name="first_name"
                                label="First Name"
                                placeholder="First Name"
                                control={control}
                                rules={{ required: 'First name is required' }}
                            />
                            <GenericInput
                                name="last_name"
                                label="Last Name"
                                placeholder="Last Name"
                                control={control}
                                rules={{ required: 'Last name is required' }}
                            />
                            <Box w="100%">
                                <Button
                                    w="100%"
                                    colorScheme="teal"
                                    isDisabled={
                                        !formState.isValid ||
                                        formState.isSubmitting
                                    }
                                    onClick={handleSubmit(onSubmit)}>
                                    Add Tenant
                                </Button>
                            </Box>
                        </Stack>
                    </FormControl>
                </ModalBody>
            </ModalContent>
        </Modal>
    );
}

export default AddTenantModal;
