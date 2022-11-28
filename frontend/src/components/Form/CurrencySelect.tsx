import { Select } from '@chakra-ui/react';
import { useMemo } from 'react';
import countryToCurrency from 'country-to-currency';
import { uniq } from 'ramda';

interface CurrencySelectProps {
    name: string;
    value: string;
    onChange: (value: string) => void;
}

function CurrencySelect({ name, value, onChange }: CurrencySelectProps) {
    const options = useMemo(() => {
        const currencies = uniq(Object.values(countryToCurrency));
        currencies.sort();

        return currencies.map((currency) => ({
            value: currency,
            label: currency,
        }));
    }, []);
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
