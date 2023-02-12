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
    Text,
} from '@chakra-ui/react';
import { IconCalendar, IconHome, IconPencil } from '@tabler/icons-react';
import { useForm } from 'react-hook-form';
import {
    calculateDueDateModifier,
    getNumberOfDaysFromDueDateModifier,
    Property,
    PropertyUpdateDto,
} from '../../../types/property';
import GenericInput from '../../Form/GenericInput';
import { useEffect } from 'react';
import getSymbolFromCurrency from 'currency-symbol-map';
import CurrencySelect from '../../Form/CurrencySelect';

interface EditPropertyModalProps {
    isOpen: boolean;
    onClose: () => void;
    onSubmit: (property: PropertyUpdateDto) => void;
    property: Property | null;
}

const defaultValues = {
    name: '',
    description: '',
    price: 0,
    location: '',
    currency: '',
    due_date_modifier: 0,
    tax_percentage: 20,
};

function EditPropertyModal({
    isOpen,
    onClose,
    onSubmit,
    property,
}: EditPropertyModalProps) {
    const { handleSubmit, formState, control, reset, watch, setValue } =
        useForm({
            mode: 'onChange',
            defaultValues,
        });

    useEffect(() => {
        if (property) {
            reset({
                name: property.name,
                description: property.description,
                price: property.price.amount,
                location: property.location,
                currency: property.price.currency,
                due_date_modifier: getNumberOfDaysFromDueDateModifier(
                    property.due_date_modifier,
                ),
                tax_percentage: property.tax_percentage,
            });
        }
    }, [property, reset]);

    const currency = watch('currency');

    return (
        <Modal isOpen={isOpen} onClose={onClose}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>Update {property?.name}</ModalHeader>
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
                            <CurrencySelect
                                name="currency"
                                value={currency}
                                onChange={(value) =>
                                    setValue('currency', value)
                                }
                            />
                            <GenericInput
                                name="tax_percentage"
                                label="Tax Percentage"
                                placeholder="Tax Percentage"
                                control={control}
                                type="number"
                                rules={{
                                    required: 'Tax Percentage is required',
                                    min: 0,
                                    max: 100,
                                }}
                                leftAdornment={'%'}
                            />
                            <GenericInput
                                name="due_date_modifier"
                                label="Due Date Modifier"
                                placeholder="Due Date Modifier"
                                control={control}
                                type="number"
                                rules={{
                                    required: 'Due Date Modifier is required',
                                    min: 0,
                                    max: 25,
                                }}
                                leftAdornment={<IconCalendar />}
                            />
                            <Text fontSize="sm">
                                Due date modifier is used when calculating the
                                due date for a payment. It is the number of days
                                after the start of the month that the payment is
                                due. (Min: 0, Max: 25)
                            </Text>
                            <Box w="100%">
                                <Button
                                    id="submit"
                                    w="100%"
                                    colorScheme="teal"
                                    disabled={
                                        !formState.isValid ||
                                        formState.isSubmitting ||
                                        property === null
                                    }
                                    onClick={handleSubmit((values) =>
                                        onSubmit({
                                            ...values,
                                            price: Number(values.price),
                                            id: property?.id ?? 0,
                                            tax_percentage: Number(
                                                values.tax_percentage,
                                            ),
                                            due_date_modifier:
                                                calculateDueDateModifier(
                                                    values.due_date_modifier,
                                                ),
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

export default EditPropertyModal;
