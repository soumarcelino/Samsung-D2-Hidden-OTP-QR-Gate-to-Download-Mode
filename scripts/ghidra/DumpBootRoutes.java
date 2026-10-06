//@category D2Vault
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionManager;
import ghidra.program.model.symbol.Reference;
import ghidra.program.model.symbol.ReferenceIterator;
import ghidra.program.model.symbol.ReferenceManager;

/**
 * Evidence collector used for the SAFZI1 boot-route audit.
 *
 * The addresses are RVAs in LinuxLoader (PE ImageBase 0).  Besides dumping the
 * selected functions, the script prints every direct caller so the report can
 * distinguish a real entry path from code that merely exists in the image.
 */
public class DumpBootRoutes extends GhidraScript {
    private DecompInterface decompiler;

    private void dump(Function function, String label) throws Exception {
        if (function == null) {
            println("MISSING " + label);
            return;
        }
        println("\n===== " + label + " :: " + function.getName() + " @ "
                + function.getEntryPoint() + " =====");
        DecompileResults result = decompiler.decompileFunction(function, 180, monitor);
        if (result.decompileCompleted()) {
            println(result.getDecompiledFunction().getC());
        } else {
            println("DECOMPILE FAILED: " + result.getErrorMessage());
        }
    }

    public void run() throws Exception {
        decompiler = new DecompInterface();
        decompiler.openProgram(currentProgram);
        FunctionManager functions = currentProgram.getFunctionManager();
        ReferenceManager references = currentProgram.getReferenceManager();
        long base = currentProgram.getImageBase().getOffset();

        String[] rvas = {
            "8a98", "32060", "56350", "56550", "595c0", "60f30", "627c0", "6f1d0", "6f3d0",
            "70650", "70d30", "70f70", "710c0", "711e0", "71300", "74060",
            "74ac0", "75390", "75e00", "cad20", "d5f28", "d6700", "d70a0"
        };

        println("PROGRAM=" + currentProgram.getName());
        println("IMAGE_BASE=" + currentProgram.getImageBase());
        for (String rva : rvas) {
            Address address = currentProgram.getAddressFactory().getDefaultAddressSpace()
                    .getAddress(base + Long.parseLong(rva, 16));
            Function function = functions.getFunctionContaining(address);
            dump(function, "RVA_" + rva);
            if (function == null) continue;
            ReferenceIterator callers = references.getReferencesTo(function.getEntryPoint());
            while (callers.hasNext()) {
                Reference reference = callers.next();
                Function caller = functions.getFunctionContaining(reference.getFromAddress());
                println("CALLER_OF_" + rva + " " + reference.getFromAddress() + " "
                        + (caller == null ? "<none>" : caller.getName() + "@" + caller.getEntryPoint()));
            }
        }
        decompiler.dispose();
    }
}
