import {
    Box,
    FormLabel,
    Input,
    InputGroup,
    InputLeftElement,
    InputRightElement,
} from '@chakra-ui/react';
import { ReactNode } from 'react';
import { Control, Controller, FieldValues, Path } from 'react-hook-form';

interface GenericInputProps<T extends FieldValues, K> {
    name: Path<T>;
    placeholder: string;
    label: string;
    control: Control<T, K>;
    type?: 'text' | 'number' | 'email' | 'password' | 'tel';
    rules?: Record<string, unknown>;
    rightAdornment?: ReactNode;
    leftAdornment?: ReactNode;
}

const GenericInput = <T extends FieldValues, K>({
    placeholder,
    label,
    name,
    control,
    type,
    leftAdornment,
    rightAdornment,
    rules = {},
}: GenericInputProps<T, K>) => {
    return (
        <Controller
            control={control}
            name={name}
            rules={rules}
            render={({ field, fieldState }) => (
                <Box>
                    <FormLabel>
                        <>
                            {label}
                            {rules.required && (
                                <span style={{ color: 'red' }}>*</span>
                            )}
                        </>
                    </FormLabel>
                    <InputGroup>
                        {rightAdornment && (
                            <InputRightElement pointerEvents="none">
                                {rightAdornment}
                            </InputRightElement>
                        )}
                        <Input
                            {...field}
                            placeholder={
                                fieldState.error?.message ?? placeholder
                            }
                            type={type}
                            isInvalid={!!fieldState.error}
                            errorBorderColor="crimson"
                        />
                        {leftAdornment && (
                            <InputLeftElement pointerEvents="none">
                                {leftAdornment}
                            </InputLeftElement>
                        )}
                    </InputGroup>
                </Box>
            )}
        />
    );
};

export default GenericInput;
