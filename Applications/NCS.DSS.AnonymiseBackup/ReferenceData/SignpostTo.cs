using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;

namespace NCS.DSS.Anonymise.ReferenceData
{
    public enum SignpostedTo
    {
        [Description("ASIST Team (Apprenticeships)")]
        ASIST = 1,

        [Description("Course Finder")]
        CourseFinder = 2,

        [Description("Job Profiles")]
        JobProfiles = 3,

        [Description("Other National Careers Service website content")]
        OtherNCSWebsiteContent = 4,

        [Description("Skills Health Check")]
        SkillsHealthCheck = 5,

        [Description("Other")]
        Other = 99

    }
}
