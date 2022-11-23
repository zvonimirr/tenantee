import {
    Modal,
    ModalBody,
    ModalCloseButton,
    ModalContent,
    ModalHeader,
    ModalOverlay,
    Text,
    Stack,
    ButtonGroup,
    Button,
} from '@chakra-ui/react';
import { useRef } from 'react';

interface ConfirmModalProps {
    title: string;
    message: string;
    onConfirm: () => void;
    onCancel: () => void;
    isOpen: boolean;
}

function ConfirmModal({
    title,
    message,
    onConfirm,
    onCancel,
    isOpen,
}: ConfirmModalProps) {
    const buttonRef = useRef<HTMLButtonElement>(null);

    return (
        <Modal isOpen={isOpen} onClose={onCancel} initialFocusRef={buttonRef}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>{title}</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <Stack spacing={4}>
                        <Text>{message}</Text>
                        <ButtonGroup>
                            <Button ref={buttonRef} onClick={onConfirm}>
                                Confirm
                            </Button>
                            <Button onClick={onCancel}>Cancel</Button>
                        </ButtonGroup>
                    </Stack>
                </ModalBody>
            </ModalContent>
        </Modal>
    );
}

export default ConfirmModal;
