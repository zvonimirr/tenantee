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
import { IconHome, IconPencil } from '@tabler/icons';
import { useForm } from 'react-hook-form';
import { PropertyDto } from '../../../types/property';
import GenericInput from '../../Form/GenericInput';
import { useEffect, useState } from 'react';
import countryToCurrency from 'country-to-currency';
import getSymbolFromCurrency from 'currency-symbol-map';
import CountrySelect from 'react-flags-select';

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
    currency: 'USD',
};

function AddPropertyModal({
    isOpen,
    onClose,
    onSubmit,
}: AddPropertyModalProps) {
    const { handleSubmit, formState, control, watch, setValue } = useForm({
        mode: 'onChange',
        defaultValues,
    });

    const currency = watch('currency');
    const [country, setCountry] = useState('US');

    useEffect(() => {
        if (country && Object.keys(countryToCurrency).includes(country)) {
            setValue(
                'currency',
                countryToCurrency[country as keyof typeof countryToCurrency],
            );
        }
    }, [country]);

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
                                leftAdornment={<IconPencil />}
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
                                leftAdornment={<IconHome />}
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
                                rightAdornment={getSymbolFromCurrency(currency)}
                            />
                            <CountrySelect
                                searchable
                                selected={country}
                                onSelect={(country) => setCountry(country)}
                            />
                            <Box w="100%">
                                <Button
                                    w="100%"
                                    colorScheme="teal"
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
