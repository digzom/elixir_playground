class AnnalynsInfiltration {
	public static boolean canFastAttack(boolean knightIsAwake) {
		if (knightIsAwake) {
			return false;
		} else {
			return true;
		}
	}

	public static boolean canSpy(boolean knightIsAwake, boolean archerIsAwake, boolean prisonerIsAwake) {
		if (knightIsAwake && archerIsAwake && prisonerIsAwake) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean canSignalPrisoner(boolean archerIsAwake, boolean prisonerIsAwake) {
		if (!archerIsAwake && prisonerIsAwake) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean canFreePrisoner(boolean knightIsAwake, boolean archerIsAwake, boolean prisonerIsAwake,
			boolean petDogIsPresent) {
		if (petDogIsPresent && !archerIsAwake) {
			return true;
		} else {
			if (!petDogIsPresent && prisonerIsAwake && !knightIsAwake && !archerIsAwake) {
				return true;
			} else {
				return false;
			}
		}

	}
}
