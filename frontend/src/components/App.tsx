import { ChakraProvider } from '@chakra-ui/react';
import { UnlockIcon, PhoneIcon } from '@chakra-ui/icons';
import Navigation from './Navigation';

const links = [
    {
        href: '/properties',
        label: <><UnlockIcon /> Properties</>,
    },
    {
        href: '/tenants',
        label: <><PhoneIcon /> Tenants</>
    }
];

function App() {
    return <ChakraProvider>
        <Navigation links={links} />
    </ChakraProvider>;
}

export default App;
