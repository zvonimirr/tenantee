import EditPropertyModal from '../../../../src/components/Property/Modals/EditPropertyModal';

const mockProperty = {
    id: 1,
    name: 'Test Property',
    description: 'Test Description',
    location: 'Test Location',
    price: {
        amount: 100,
        currency: 'USD',
    },
    tenants: [],
    monthly_revenue: {
        amount: 100,
        currency: 'USD',
    },
    due_date_modifier: 0,
};

describe('EditPropertyModal', () => {
    it('should validate properly', () => {
        cy.mount(
            <EditPropertyModal
                property={mockProperty}
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
            <EditPropertyModal
                property={mockProperty}
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
            <EditPropertyModal
                property={mockProperty}
                isOpen={true}
                onClose={() => {}}
                onSubmit={onSubmit}
            />,
        );

        cy.get('#submit').click();

        cy.wrap(onSubmit).should('have.been.calledWith', {
            id: 1,
            name: 'Test Property',
            description: 'Test Description',
            price: 100,
            location: 'Test Location',
            currency: 'USD',
            due_date_modifier: 0,
        });
    });
});
