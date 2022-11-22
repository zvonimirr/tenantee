import Breadcrumbs from '../../../src/components/Navigation/Breadcrumbs';

describe('Breadcrumbs.cy.tsx', () => {
    it('should render properly', () => {
        cy.mount(
            <Breadcrumbs
                items={[
                    {
                        label: 'Cypress',
                        href: 'https://www.cypress.io/',
                    },
                ]}
            />,
        );

        cy.get('a').last().should('have.text', 'Cypress');
        cy.get('a')
            .last()
            .should('have.attr', 'href', 'https://www.cypress.io/');
    });
});
