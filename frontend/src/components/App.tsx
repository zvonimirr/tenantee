import { ChakraProvider } from '@chakra-ui/react';
import Navigation from './Navigation';
import { createBrowserRouter, RouterProvider } from 'react-router-dom';
import Home from '../pages/Home';
import DrawerProvider from '../hooks/useDrawer';
import { IconKey, IconUsers } from '@tabler/icons';
import Label from './Navigation/Label';

const links = [
    {
        href: '/properties',
        label: <Label icon={<IconKey />} label="Properties" />,
    },
    {
        href: '/tenants',
        label: <Label icon={<IconUsers />} label="Tenants" />,
    },
];

const router = createBrowserRouter([
    {
        path: '/',
        element: <Home />,
    },
]);

function App() {
    return (
        <ChakraProvider>
            <DrawerProvider>
                <Navigation links={links} />
                <RouterProvider router={router} />
            </DrawerProvider>
        </ChakraProvider>
    );
}

export default App;
