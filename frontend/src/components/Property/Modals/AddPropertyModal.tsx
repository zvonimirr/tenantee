import {
    Box,
    Button,
    FormControl,
    FormLabel,
    Input,
    Modal,
    ModalBody,
    ModalCloseButton,
    ModalContent,
    ModalHeader,
    ModalOverlay,
    Stack,
} from '@chakra-ui/react';
import { useForm } from 'react-hook-form';
import { PropertyDto } from '../../../types/property';

interface AddPropertyModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSubmit: (property: PropertyDto) => void;
}

const defaultValues = {
    name: '',
    description: '',
    price: 0,
    location: '',
};

function AddPropertyModal({
    isOpen,
    onClose,
    onSubmit,
}: AddPropertyModalProps) {
    const { register, handleSubmit, formState } = useForm({
        mode: 'onChange',
        defaultValues,
    });

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Add New Property</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <FormControl>
                        <Stack spacing={4}>
                            <Box>
                                <FormLabel>Name</FormLabel>
                                <Input
                                    {...register('name', {
                                        required: 'Name is required',
                                    })}
                                    placeholder={
                                        formState.errors.name?.message ??
                                        'Name of the property'
                                    }
                                />
                            </Box>
                            <Box>
                                <FormLabel>Description</FormLabel>
                                <Input
                                    {...register('description')}
                                    placeholder="Description of the property (optional)"
                                />
                            </Box>
                            <Box>
                                <FormLabel>Location</FormLabel>
                                <Input
                                    {...register('location', {
                                        required: 'Location is required',
                                    })}
                                    placeholder={
                                        formState.errors.location?.message ??
                                        'Location of the property'
                                    }
                                />
                            </Box>
                            <Box>
                                <FormLabel>Price</FormLabel>
                                <Input
                                    {...register('price', {
                                        required: 'Price is required',
                                        min: {
                                            value: 0,
                                            message:
                                                'Price must be greater than 0',
                                        },
                                    })}
                                    type="number"
                                    placeholder={
                                        formState.errors.price?.message ??
                                        'Price of the property'
                                    }
                                />
                            </Box>
                            <Box>
                                <Button
                                    disabled={
                                        !formState.isValid ||
                                        formState.isSubmitting
                                    }
                                    onClick={handleSubmit((values) =>
                                        onSubmit({
                                            property: {
                                                ...values,
                                                price: Number(values.price),
                                            },
                                        }),
                                    )}>
                                    Add Property
                                </Button>
                            </Box>
                        </Stack>
                    </FormControl>
                </ModalBody>
            </ModalContent>
        </Modal>
    );
}

export default AddPropertyModal;
