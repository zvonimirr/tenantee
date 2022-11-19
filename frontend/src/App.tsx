import { useEffect, useState } from "react";
import "./App.css";

interface Tenant {
  first_name: string;
  last_name: string;
  email: string;
  phone: string;
}

interface Property {
  name: string;
  description?: string;
  location: string;
  price: {
    amount: number;
    currency: string;
  };
  tenants: Tenant[];
}

function App() {
  const [properties, setProperties] = useState<Property[]>([]);

  useEffect(() => {
    fetch(`${import.meta.env.VITE_API_URL}/api/properties`).then((res) =>
      res.json().then((data) => setProperties(data.properties))
    );
  }, []);

  return (
    <div className="App">
      <div>
        <img src="/vite.svg" className="logo" alt="Vite logo" />
      </div>
      <h1>Tenantee</h1>
      <p>List of properties:</p>
      <ul>
        {properties.map((property) => (
          <li key={property.name}>
            <h2>{property.name}</h2>
            <p>{property.description}</p>
            <p>{property.location}</p>
            <p>
              {property.price.amount} {property.price.currency}
            </p>
            <ul>
              {property.tenants.map((tenant) => (
                <li key={tenant.email}>
                  <p>{tenant.first_name}</p>
                  <p>{tenant.last_name}</p>
                  <p>{tenant.email}</p>
                  <p>{tenant.phone}</p>
                </li>
              ))}
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
