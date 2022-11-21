import {
    Box,
    Breadcrumb,
    BreadcrumbItem,
    BreadcrumbLink,
} from '@chakra-ui/react';
import { IconChevronRight, IconMenu2 } from '@tabler/icons';
import { ReactNode } from 'react';
import { useDrawer } from '../../hooks/useDrawer';

interface BreadcrumbsItem {
    href: string;
    label: ReactNode;
}

interface BreadcrumbsProps {
    items: BreadcrumbsItem[];
}

function Breadcrumbs({ items }: BreadcrumbsProps) {
    const { openDrawer } = useDrawer();

    return (
        <Box boxShadow="lg" p={4}>
            <Breadcrumb spacing="8px" separator={<IconChevronRight />}>
                <BreadcrumbItem>
                    <BreadcrumbLink onClick={openDrawer}>
                        <IconMenu2 />
                    </BreadcrumbLink>
                </BreadcrumbItem>
                {items.map((item) => (
                    <BreadcrumbItem key={item.href}>
                        <BreadcrumbLink href={item.href}>
                            {item.label}
                        </BreadcrumbLink>
                    </BreadcrumbItem>
                ))}
            </Breadcrumb>
        </Box>
    );
}

export default Breadcrumbs;
