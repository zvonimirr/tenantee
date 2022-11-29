import AddPropertyModal from '../../../../src/components/Property/Modals/AddPropertyModal';

describe('AddPropertyModal', () => {
    it('should validate properly', () => {
        cy.mount(
            <AddPropertyModal
                isOpen={true}
                onClose={() => {}}
                onSubmit={() => {}}
            />,
        );

        cy.get('#submit').should('be.disabled');

        cy.get('input').each((input) => {
            cy.wrap(input).type('12');
        });

        cy.get('#submit').should('not.be.disabled');
    });

    it('should call onClose when close button is clicked', () => {
        const onClose = cy.stub();

        cy.mount(
            <AddPropertyModal
                isOpen={true}
                onClose={onClose}
                onSubmit={() => {}}
            />,
        );

        cy.get('button').first().click();
    });

    it('should submit properly', () => {
        const onSubmit = cy.stub();

        cy.mount(
            <AddPropertyModal
                isOpen={true}
                onClose={() => {}}
                onSubmit={onSubmit}
            />,
        );

        cy.get('input').each((input) => {
            cy.wrap(input).type('12');
        });

        cy.get('#submit').click();

        cy.wrap(onSubmit).should('have.been.calledWith', {
            name: '12',
            description: '12',
            location: '12',
            price: 12,
            currency: 'USD',
            due_date_modifier: 12 * 60 * 60 * 24,
        });
    });
});
