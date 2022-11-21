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
    return (
        <Modal isOpen={isOpen} onClose={onCancel}>
            <ModalOverlay />
            <ModalContent>
                <ModalHeader>{title}</ModalHeader>
                <ModalCloseButton />
                <ModalBody>
                    <Stack spacing={4}>
                        <Text>{message}</Text>
                        <ButtonGroup>
                            <Button onClick={onConfirm}>Confirm</Button>
                            <Button onClick={onCancel}>Cancel</Button>
                        </ButtonGroup>
                    </Stack>
                </ModalBody>
            </ModalContent>
        </Modal>
    );
}

export default ConfirmModal;
