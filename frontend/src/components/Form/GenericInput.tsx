import { Box, FormLabel, Input } from '@chakra-ui/react';
import { Control, Controller } from 'react-hook-form';

interface GenericInputProps {
    name: string;
    placeholder: string;
    label: string;
    control: Control<any, any>;
    type?: 'text' | 'number' | 'email' | 'password';
    rules?: Record<string, any>;
}

function GenericInput({
    placeholder,
    label,
    name,
    control,
    type,
    rules = {},
}: GenericInputProps) {
    return (
        <Controller
            control={control}
            name={name}
            rules={rules}
            render={({ field, fieldState }) => (
                <Box>
                    <FormLabel>
                        {label}
                        {rules.required && (
                            <span style={{ color: 'red' }}>*</span>
                        )}
                    </FormLabel>
                    <Input
                        {...field}
                        placeholder={fieldState.error?.message ?? placeholder}
                        type={type}
                        isInvalid={!!fieldState.error}
                        errorBorderColor="crimson"
                    />
                </Box>
            )}
        />
    );
}

export default GenericInput;
