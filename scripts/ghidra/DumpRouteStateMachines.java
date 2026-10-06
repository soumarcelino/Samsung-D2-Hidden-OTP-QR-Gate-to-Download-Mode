//@category D2Vault
import ghidra.app.decompiler.DecompInterface;
import ghidra.app.decompiler.DecompileResults;
import ghidra.app.script.GhidraScript;
import ghidra.program.model.address.Address;
import ghidra.program.model.listing.Function;
import ghidra.program.model.listing.FunctionManager;

/** Dump only the boot/key state machines, keeping headless evidence readable. */
public class DumpRouteStateMachines extends GhidraScript {
    public void run() throws Exception {
        DecompInterface decompiler = new DecompInterface();
        decompiler.openProgram(currentProgram);
        FunctionManager functions = currentProgram.getFunctionManager();
        long base = currentProgram.getImageBase().getOffset();
        String[] rvas = {
            "8b3c", "25ec0", "26020", "26240", "26950", "26aa0", "31db0", "595c0", "5cd50", "60d30", "60f30", "6f250", "6f3d0",
            "70650", "70f70", "710c0", "711e0", "71300", "717f0", "719a0",
            "71e90", "72200", "72340", "726e0", "72ba0", "74060", "78660",
            "789e0", "c25c0", "c2610", "cad20", "c3c70", "d5f10", "d6700", "d7540"
        };
        for (String rva : rvas) {
            Address address = currentProgram.getAddressFactory().getDefaultAddressSpace()
                    .getAddress(base + Long.parseLong(rva, 16));
            Function function = functions.getFunctionContaining(address);
            println("\n===== RVA_" + rva + " "
                    + (function == null ? "MISSING" : function.getName() + " @ " + function.getEntryPoint())
                    + " =====");
            if (function == null) continue;
            DecompileResults result = decompiler.decompileFunction(function, 240, monitor);
            println(result.decompileCompleted() ? result.getDecompiledFunction().getC()
                    : "FAILED: " + result.getErrorMessage());
        }
        decompiler.dispose();
    }
}
