import { Box, Drawer, DrawerBody, DrawerCloseButton, DrawerContent, DrawerHeader, DrawerOverlay, Link, Stack } from '@chakra-ui/react';
import { ReactNode } from 'react';

interface NavigationLink {
    href: string;
    label: ReactNode;
}

interface NavigationProps {
    links: NavigationLink[]
}

function Navigation({ links }: NavigationProps) {
    return <Drawer isOpen placement='left' onClose={() => null}>
        <DrawerOverlay />
        <DrawerContent>
            <DrawerCloseButton />
            <DrawerHeader>Tenantee</DrawerHeader>

            <DrawerBody>
                <Stack spacing='12px'>
                    {links.map(link => <Box key={link.href}><Link href={link.href}>{link.label}</Link></Box>)}
                </Stack>
            </DrawerBody>
        </DrawerContent>
    </Drawer>;
}

export default Navigation;