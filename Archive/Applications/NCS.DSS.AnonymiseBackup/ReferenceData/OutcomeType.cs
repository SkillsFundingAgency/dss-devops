using System;
using System.ComponentModel;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace NCS.DSS.Anonymise.ReferenceData
{
    public enum OutcomeType
    {
        [Description("Customer Satisfaction")]
        CustomerSatisfaction = 1,

        [Description("Career Management")]
        CareersManagement = 2,

        [Description("Sustainable Employment")]
        SustainableEmployment = 3,

        [Description("Accredited Learning")]
        AccreditedLearning = 4,

        [Description("Career Progression")]
        CareerProgression = 5,
    }
}
