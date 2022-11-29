import PropertyCard from '../../../src/components/Property/PropertyCard';

describe('PropertyCard', () => {
    it('should render and react to events properly', () => {
        const onClick = cy.stub();
        const onDeleteClick = cy.stub();
        const onEditClick = cy.stub();

        cy.mount(
            <PropertyCard
                onClick={onClick}
                onDeleteClick={onDeleteClick}
                onEditClick={onEditClick}
                property={{
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
                }}
            />,
        );

        cy.get('.chakra-text').should('have.text', 'Test Property');
        cy.get('.chakra-text').click();
        cy.get('.icon-tabler-pencil').click();
        cy.get('.icon-tabler-trash').click();

        cy.wrap(onClick).should('have.been.called');
        cy.wrap(onDeleteClick).should('have.been.called');
        cy.wrap(onEditClick).should('have.been.called');
    });
});
