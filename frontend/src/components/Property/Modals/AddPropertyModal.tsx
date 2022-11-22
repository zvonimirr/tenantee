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
import { PropertyDto } from '../../../types/property';
import GenericInput from '../../Form/GenericInput';

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
    const { handleSubmit, formState, control } = useForm({
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
                            <GenericInput
                                name="name"
                                label="Name"
                                placeholder="Name of the property"
                                control={control}
                                rules={{
                                    required: 'Name is required',
                                }}
                            />
                            <GenericInput
                                name="description"
                                label="Description"
                                placeholder="Description of the property (optional)"
                                control={control}
                            />
                            <GenericInput
                                name="location"
                                label="Location"
                                placeholder="Location of the property"
                                control={control}
                                rules={{
                                    required: 'Location is required',
                                }}
                            />
                            <GenericInput
                                name="price"
                                label="Price"
                                placeholder="Price of the property"
                                control={control}
                                type="number"
                                rules={{
                                    required: 'Price is required',
                                    min: 1,
                                }}
                            />
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
