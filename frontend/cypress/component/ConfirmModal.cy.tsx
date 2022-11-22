import ConfirmModal from '../../src/components/Modals/ConfirmModal';

describe('ConfirmModal.cy.ts', () => {
    it('should render properly', () => {
        cy.mount(
            <ConfirmModal
                title="Cypress"
                message="Cypress is awesome"
                isOpen={true}
                onCancel={() => {}}
                onConfirm={() => {}}
            />,
        );

        cy.get('header').should('contain', 'Cypress');
        cy.get('p').should('contain', 'Cypress is awesome');

        cy.get('button').should('have.length', 3);
        cy.get('button').eq(1).should('contain', 'Confirm');
        cy.get('button').last().should('contain', 'Cancel');
    });
});
