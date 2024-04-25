import Navbar from './navbar/Navbar';
import { Outlet } from "react-router-dom";

function Layout() {
  return (
    <div>
      <div className="flex-grow">
        <main><Outlet /></main>
      </div>
      <div className="fixed inset-y-0 right-0">
        <Navbar />
      </div>
    </div>
  );
}

export default Layout;