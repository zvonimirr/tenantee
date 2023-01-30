import { Select } from '@chakra-ui/react';
import countryToCurrency from 'country-to-currency';
import { uniq, sort } from 'ramda';

interface CurrencySelectProps {
    name: string;
    value: string;
    onChange: (value: string) => void;
}

const currencies = sort<string>(
    (a, b) => a.localeCompare(b),
    uniq(Object.values(countryToCurrency)),
);

const options = currencies.map((currency) => ({
    value: currency,
    label: currency,
}));

function CurrencySelect({ name, value, onChange }: CurrencySelectProps) {
    return (
        <Select
            name={name}
            value={value}
            onChange={(e) => onChange(e.target.value)}>
            {options.map((option) => (
                <option key={option.value} value={option.value}>
                    {option.label}
                </option>
            ))}
        </Select>
    );
}

export default CurrencySelect;
