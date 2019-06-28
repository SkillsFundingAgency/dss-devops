using System;

namespace NCS.DSS.AnonymiseBackup.Models
{
    public interface IAnonymise
    {
        void SetRandomSeed(Random randSeed);
        void Anonymise();
    }
}
