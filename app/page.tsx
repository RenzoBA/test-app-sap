import Link from "next/link";

export default function Home() {
  return (
    <div>
      <Link href="/user-sap" className="border p-2 bg-blue-300">
        USER SAP
      </Link>
    </div>
  );
}
