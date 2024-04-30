import Navbar from './navbar/Navbar';
import { Outlet } from "react-router-dom";

function Layout() {
  return (
    <div className="flex w-screen">
      <div className="flex-grow">
        <main><Outlet /></main>
      </div>
      <div className="w-auto">
        <Navbar />
      </div>
    </div>
  );
}

export default Layout;
